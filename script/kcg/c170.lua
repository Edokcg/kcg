--グランエルＡ3
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(id,2))
	e01:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e01:SetType(EFFECT_TYPE_ACTIVATE)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetCost(s.actcost)
	e01:SetTarget(s.acttarget)
	e01:SetOperation(s.actactivate)
	c:RegisterEffect(e01)

	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,5))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_HAND)
	e7:SetCost(Cost.SelfDiscard)
	e7:SetTarget(s.thtg3)
	e7:SetOperation(s.thop3)
	c:RegisterEffect(e7)

	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,6))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon2)
	c:RegisterEffect(e1)

	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.eqcon)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_SZONE,0)
	e11:SetCode(EFFECT_EQUIP_MONSTER)
	e11:SetCondition(s.eecon)
	e11:SetTarget(s.eefilter)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e12)
	
	--Add to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.thtg2)
	e6:SetOperation(s.thop2)
	c:RegisterEffect(e6)
end
s.listed_series={SET_MEKLORD_EMPEROR,SET_MEKLORD,0x507}
s.listed_names={312,100000067}

function s.thfilter3(c)
	return c:IsCode(100000067) and c:IsDestructable()
end
function s.thtg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter3,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK|LOCATION_HAND)
end
function s.thop3(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,s.thfilter3,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

function s.actcostfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x507) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(s.actcostfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.actcostfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.actactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,false,1,true,c,c:GetControler(),nil,false,nil,0x507)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,false,true,true,c,nil,nil,false,nil,0x507)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD_EMPEROR)
end
function s.sdcon2(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.eecon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.eefilter(e,c)
	return c:IsFaceup() and c:GetEquipTarget() and c:IsOriginalType(TYPE_MONSTER) and c:GetEquipTarget():IsSetCard(SET_MEKLORD)
end

function s.spcon30(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(170)==0
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function s.spfilter(c,e,tp)
	  if c:GetEquipTarget()~=nil then
	return c:IsFaceup() and c:IsOriginalType(TYPE_MONSTER) and c:GetEquipTarget():IsSetCard(SET_MEKLORD) end
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	e:GetHandler():RegisterFlagEffect(170,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function s.piercetg(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	  local tc2=Duel.GetFirstTarget()
	if tc2 and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		  --immune
		  local e121=Effect.CreateEffect(c)
		  e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e121:SetType(EFFECT_TYPE_SINGLE)
		  e121:SetRange(LOCATION_MZONE)
		  e121:SetCode(EFFECT_IMMUNE_EFFECT)
		  e121:SetValue(s.efilter)
		  e121:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		  c:RegisterEffect(e121)
		  local e5=e121:Clone()
		  e5:SetCode(EFFECT_CHANGE_CODE)
		  e5:SetValue(tc2:GetCode())
		  c:RegisterEffect(e5)
		  local e6=e121:Clone()
		  e6:SetCode(EFFECT_SET_BASE_ATTACK)
		  e6:SetValue(tc2:GetBaseAttack())
		  c:RegisterEffect(e6)
		  local e7=e121:Clone()
		  e7:SetCode(EFFECT_SET_BASE_DEFENSE)
		  e7:SetValue(tc2:GetBaseDefense())
		  c:RegisterEffect(e7)
		  local e8=e121:Clone()
		  e8:SetCode(EFFECT_CHANGE_TYPE)
		  e8:SetValue(tc2:GetOriginalType())
		  c:RegisterEffect(e8)
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_SINGLE)
		  --e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e3:SetCode(EFFECT_PIERCE)
			--e3:SetRange(LOCATION_MZONE)
		  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		  c:RegisterEffect(e3) 
	  end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsType(TYPE_SYNCHRO) and eg:GetFirst():GetBattleTarget():IsSetCard(SET_MEKLORD) and eg:GetFirst():GetBattleTarget():IsControler(tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and eg:GetFirst():IsAbleToChangeControler()
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function s.eqlimit(e,c)
	local tc2=e:GetLabelObject()
	return c==tc2
	--return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	if #g<1 then return end
	local tc2=g:GetFirst()
	local tc=eg:GetFirst()
	if not Duel.Equip(tp,tc,tc2,false) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(tc2)
	tc:RegisterEffect(e1)
end

function s.thfilter2(c)
	return c:IsCode(312) and c:IsAbleToHand()
end
function s.thfilter4(c)
	return c:IsCode(312) and c:IsSSetable()
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.thfilter4,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,3)},
		{b2,aux.Stringid(id,4)})
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
	if op==2 then
		e:SetCategory(CATEGORY_SET)
		Duel.SetOperationInfo(0,CATEGORY_SET,nil,1,tp,LOCATION_GRAVE)
	end
	Duel.SetTargetParam(op)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op==2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.thfilter4,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	end
end