--機皇帝グランエル∞
Duel.LoadScript("c420.lua")
local s, id = GetID()
function s.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)

	-- local e6=Effect.CreateEffect(c)
	-- e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	-- e6:SetCode(EVENT_DESTROYED)
	-- e6:SetCategory(CATEGORY_DESTROY)
	-- e6:SetCondition(s.descon)
	-- e6:SetTarget(s.destg)
	-- e6:SetOperation(s.desop)
	-- c:RegisterEffect(e6)

	--cannot be target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.effval)
	c:RegisterEffect(e8)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(s.atkfilter)
	c:RegisterEffect(e7)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000056,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(90162951)
	c:RegisterEffect(e5)
end
s.listed_names={100000062,100000063,100000064,100000065}
s.listed_series={SET_MEKLORD,0x560,0x549,0x524}

function s.filter0(c,tp)
	return c:IsMonster() and (c:GetReason()&(REASON_DESTROY|REASON_EFFECT))==(REASON_DESTROY|REASON_EFFECT) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter0,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or #sg>0)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(100000062,100000063,100000064,100000065) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,100000062) and sg:IsExists(Card.IsCode,1,nil,100000063) and sg:IsExists(Card.IsCode,1,nil,100000064) and sg:IsExists(Card.IsCode,1,nil,100000065)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or (ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
		if not s.rescon(sg) then return end
		local spg=aux.SelectUnselectGroup(sg,e,tp,4,4,s.rescon,1,tp,HINTMSG_SPSUMMON)
		if #sg>0 then
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.eqfilter2(c)
	return c:IsFaceup() 
	--and bit.band(c:GetOriginalType(),TYPE_SYNCHRO)~=0
end
function s.val(e,c)
	  local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter2,nil)
	  local tatk=0
	  if g:GetCount()>0 then
	  local tc=g:GetFirst()
	  while tc do
	  local atk=tc:GetTextAttack()
	  tatk=tatk+atk
	  tc=g:GetNext() end end
	return tatk
end
function s.val2(e,c)
	return Duel.GetLP(c:GetControler())
end

function s.exfilter(c,fid)
	return c:IsFaceup() and c:IsSetCard(0x3013) and (fid==nil or c:GetFieldID()<fid)
end
function s.excon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function s.splimit(e,se,sp,st,spos,tgp)
	if bit.band(spos,POS_FACEDOWN)~=0 then return true end
	return not Duel.IsExistingMatchingCard(s.exfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end


function s.efilter(e,te)
	return te:IsActiveType(TYPE_QUICKPLAY+TYPE_COUNTER+TYPE_SPELL+TYPE_TRAP+TYPE_EFFECT)
end

function s.descon(e)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_ONFIELD and c:GetPreviousPosition()==POS_FACEUP
end
function s.desfilter(c)
	return (c:IsWisel() or c:IsSkiel() or c:IsGranel()) and not c:IsSetCard(0x3013) and c:IsDestructable()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,c)
	Duel.Destroy(sg,REASON_EFFECT)
end

function s.effval(e,re)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end

function s.atkfilter(e,c)
	return (c:IsWisel() or c:IsSkiel() or c:IsGranel()) and not c:IsSetCard(0x3013) and c~=e:GetHandler() 
end

function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				--tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
