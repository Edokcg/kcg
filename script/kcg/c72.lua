--暗黒方界神クリムゾン・ノヴァ
--Crimson Nova the Dark Cubic Lord
local s,id=GetID()
function s.initial_effect(c)
	--Special summon procedure (from hand)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.cost)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--Unaffected by activated monster effects, whose original ATK is 3000 or less
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)

	--Make it be able to make a second attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(s.atkcon)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)

	--Inflict 3000 damage to both players
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.damcon)
	e5:SetTarget(s.damtg)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)

	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(s.spsop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD_P)
	e8:SetOperation(s.op)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
s.listed_series={0xe3}

-- function s.spcfilter(c)
-- 	return c:IsSetCard(0xe3) and not c:IsPublic()
-- end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetClassCount(Card.GetCode)==#sg,sg:GetClassCount(Card.GetCode)~=#sg
end
-- function s.spcon(e,c)
-- 	local c=e:GetHandler()
-- 	if c==nil then return true end
-- 	local tp=c:GetControler()
-- 	local hg=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,c)
-- 	return aux.SelectUnselectGroup(hg,e,tp,3,3,s.rescon,0)
-- end
-- function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
-- 	local c=e:GetHandler()
-- 	local hg=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,c)
-- 	local g=aux.SelectUnselectGroup(hg,e,tp,3,3,s.rescon,1,tp,HINTMSG_CONFIRM,nil,nil,true)
-- 	if #g>0 then
-- 		g:KeepAlive()
-- 		e:SetLabelObject(g)
-- 		return true
-- 	end
-- 	return false
-- end
-- function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
-- 	local g=e:GetLabelObject()
-- 	if not g then return end
-- 	Duel.ConfirmCards(1-tp,g)
-- 	Duel.ShuffleHand(tp)
-- 	Duel.Overlay(c,g)
-- 	g:DeleteGroup()
-- end

function s.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.CheckEvent(EVENT_CHAINING)
end
function s.filter(c)
	return c:IsSetCard(0xe3) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,c)
	if chk==0 then return #hg>0 end
	local g=aux.SelectUnselectGroup(hg,e,tp,3,3,s.rescon,1,tp,HINTMSG_CONFIRM,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
	end
end
function s.sptg(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,3,nil,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function s.spop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not g then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		for tc in aux.Next(g) do
			if tc:GetOverlayCount()~=0 then Duel.Overlay(c,tc:GetOverlayGroup()) end
		end
		Duel.Overlay(c,g)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetOwner():GetBaseAttack()<=e:GetHandler():GetAttack() and te:GetOwner():GetBaseAttack()>=0
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	--Can make a second attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3201)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,e:GetHandler():GetAttack())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,e:GetHandler():GetAttack(),REASON_EFFECT,true)
	Duel.Damage(1-tp,e:GetHandler():GetAttack(),REASON_EFFECT,true)
	Duel.RDComplete()
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3)
end
function s.spsop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	if not mg or mg:FilterCount(s.spfilter,nil,e,tp)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<mg:GetCount() 
	   or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and mg:GetCount()>1) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	mg:DeleteGroup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if g:GetCount()>0 then
	local mg=g:Filter(s.spfilter,nil,e,tp)
	mg:KeepAlive()
	e:GetLabelObject():SetLabelObject(mg) end
end