--蛇神凱
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)

	--Cannot Lose
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetCode(EFFECT_CANNOT_LOSE_LP)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(1,0)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	local e19=e18:Clone()
	e19:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e19)
	local e20=e18:Clone()
	e20:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e20)
			
	  --spsummon success
	  local e5=Effect.CreateEffect(c)
	  e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	  e5:SetOperation(s.sucop)
	  c:RegisterEffect(e5)

	  --attack cost
	  local e6=Effect.CreateEffect(c)
	  e6:SetType(EFFECT_TYPE_SINGLE)
	  e6:SetCode(EFFECT_ATTACK_COST)
	  e6:SetCost(s.atcost)
	  e6:SetOperation(s.atop)
	  c:RegisterEffect(e6)

	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e9)

	--不能被各种方式解放
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_UNRELEASABLE_SUM)
	e12:SetValue(1)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e14)

	--不会被卡的效果破坏、除外、返回手牌和卡组、送去墓地、无效化、改变控制权、变为里侧表示、作为特殊召唤素材
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e101)
	local e102=e101:Clone()
	e102:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e102)
	local e103=e102:Clone()
	e103:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e103)
	local e104=e103:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e106=e104:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e106:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e107:Clone()
	e108:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e108:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e108)
	local e111=e107:Clone()
	e111:SetCode(EFFECT_CANNOT_RELEASE)
	c:RegisterEffect(e111)
	local e112=e107:Clone()
	e112:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e112)

	local e1235=Effect.CreateEffect(c)
	e1235:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1235:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1235:SetCode(EVENT_LEAVE_FIELD)
	e1235:SetOperation(s.lose)
	c:RegisterEffect(e1235)
end
s.listed_names={12399}

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(12399)
end

function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttp=c:GetControler()
	if Duel.GetBattleDamage(ttp)>=Duel.GetLP(ttp) then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(ttp)-1)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,ttp) end
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then 
		return true 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) 
end
function s.rdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(tp)-1)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e3,tp) 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(tp)-1)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e3,tp) 
	end 
end

function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_EFFECT)
end

function s.atcost(e,c,tp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_DECK,0)>=10
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(e:GetHandler():GetControler(),10,REASON_COST)
	Duel.AttackCostPaid()
end

function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end

function s.losecon(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetHandler() 
	  local ttp=tc:GetOwner() 
	return tc:IsFacedown() or tc:IsDisabled() 
end
function s.lose(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetHandler() 
	  local ttp=tc:GetOwner() 
	  if Duel.IsExistingMatchingCard(Card.IsCode,ttp,LOCATION_EXTRA,0,1,nil,123108) and Duel.IsExistingMatchingCard(s.cfilter,ttp,LOCATION_FZONE,0,1,nil) then return end
	  local WIN_REASON_DIVINE_SERPENT=0x103
	  Duel.Win(1-ttp,WIN_REASON_DIVINE_SERPENT)
end

function s.cfilter(c)
	   return c:IsSetCard(0x900) and c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsCode(123108) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) 
							and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,1,tp,tp,true,true,POS_FACEUP)
	end
end
