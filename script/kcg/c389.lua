--Ｎｏ.93 希望皇ホープ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedureX(c,s.xyzfilter,nil,2,nil,nil,Xyz.InfiniteMats,nil,false,s.xyzcheck)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--spsummon condition
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_SPSUMMON_CONDITION)
	e13:SetValue(s.splimit)
	--c:RegisterEffect(e13)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2067935,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)

	--不会被卡的效果破坏
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e100:SetValue(s.efilter)
	c:RegisterEffect(e100)
	  local e101=Effect.CreateEffect(c)
	  e101:SetType(EFFECT_TYPE_SINGLE)
	e101:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e101:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e101:SetValue(s.efilter)
	c:RegisterEffect(e101)

	--immune
	local e121=Effect.CreateEffect(c)
	e121:SetType(EFFECT_TYPE_SINGLE)
	e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e121:SetRange(LOCATION_MZONE)
	e121:SetCode(EFFECT_IMMUNE_EFFECT)
	e121:SetValue(s.efilter1)
	c:RegisterEffect(e121)

	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetRange(LOCATION_MZONE) 
	  e1:SetTargetRange(1,0)
	e1:SetCondition(s.con)   
	  e1:SetValue(0)
	  c:RegisterEffect(e1)

	local ch=Effect.CreateEffect(c)
	ch:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ch:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ch:SetCode(EVENT_DESTROYED)
	  ch:SetCondition(s.checkcon)
	ch:SetOperation(s.checkop)
	Duel.RegisterEffect(ch,0)

	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(4779091,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	  e4:SetLabelObject(ch)
	e4:SetTarget(s.destg)
	  e4:SetOperation(s.desop) 
	c:RegisterEffect(e4)

	local ge2=Effect.CreateEffect(c) 
	  ge2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	  ge2:SetCode(EVENT_TURN_END)
	  ge2:SetCountLimit(1)
	ge2:SetOperation(s.checkop2) 
	  ge2:SetLabelObject(ch)
	  Duel.RegisterEffect(ge2,0)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5257687,0))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(s.cotg)
	e5:SetOperation(s.coop)
	c:RegisterEffect(e5)
end
s.xyz_number=93
s.listed_series={0x48}

function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsSetCard(0x48,xyz,sumtype,tp) and c:GetOverlayCount()>0
end
function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.filter21(c)
	return c:IsSetCard(0x48) or c:IsSetCard(0x1048) or c:IsSetCard(0x2048)
end
function s.splimit(e,se,sp,st)
	return Duel.IsExistingMatchingCard(s.filter21,e:GetHandler():GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil)
end

function s.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ocount=c:GetOverlayCount()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ocount,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ocount=c:GetOverlayCount()
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if ft<=0 or ocount<1 then return end
	if ocount>ft then ocount=ft end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ocount=1 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,ocount,nil,e,tp)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete() 
			tc:CompleteProcedure()
		end
	end
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function s.efilter(e)
	return Duel.IsExistingMatchingCard(s.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler()) 
end
function s.spfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x48) or c:IsSetCard(0x1048) or c:IsSetCard(0x2048))
end
function s.efilter1(e,te)
	return Duel.IsExistingMatchingCard(s.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler()) 
	  and te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	  return Duel.IsExistingMatchingCard(s.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end

function s.spfilter2(c,tp)
	return (c:IsSetCard(0x48) or c:IsSetCard(0x1048) or c:IsSetCard(0x2048)) and c:IsControler(tp)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	  return eg:FilterCount(s.spfilter2,nil,e:GetHandler():GetControler())>0 
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local count=eg:FilterCount(s.spfilter2,nil,e:GetHandler():GetControler())
	e:SetLabel(e:GetLabel()+count)
end

function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	  e:GetLabelObject():SetLabel(0)
end

function s.sfilter(c)
	return c:IsOnField() and aux.TRUE
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  local count=e:GetLabelObject():GetLabel()
	  if chkc then return s.sfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.sfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) and count>0 end
		local g=Duel.GetMatchingGroup(s.sfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	  if g:GetCount()<count then count=g:GetCount() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  local g2=Duel.SelectTarget(tp,s.sfilter,tp,0,LOCATION_MZONE,count,count,nil)
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,count,0,0) 
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end

function s.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	  local tc=e:GetHandler():GetReasonCard()
	  if e:GetHandler():IsReason(REASON_EFFECT) then tc2=re:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ((tc~=nil and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp)) or (bit.band(r,REASON_BATTLE)==0 and tc2~=nil and tc2:IsType(TYPE_MONSTER) and tc2:IsControler(1-tp))) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.coop(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetHandler():GetReasonCard()
	  if e:GetHandler():IsReason(REASON_EFFECT) then tc2=re:GetHandler() end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	  if bit.band(r,REASON_BATTLE)==0 and tc2~=nil and tc2:IsType(TYPE_MONSTER) and tc2:IsControler(1-tp) then
	   Duel.GetControl(tc2,tp,0,0) end 
	  if tc~=nil and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
	   Duel.GetControl(tc,tp,0,0) end 
	  end
end