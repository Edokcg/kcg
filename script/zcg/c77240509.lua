--妖歌·异约魂印披风(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER) then
	  local ag=Duel.GetOperatedGroup()
	  local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_MONSTER)
	  local atk=0
	  local tc=ag:GetFirst()
	  while tc do
	  atk=atk+tc:GetAttack()
	  tc=ag:GetNext()
	  end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk/2)
	e1:SetReset(RESET_EVENT+0xff0000)
	g:GetFirst():RegisterEffect(e1)
end
end
function s.setfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,0,LOCATION_GRAVE,1,nil)  end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst(),true)
	end
end
function s.acfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:CheckActivateEffect(true,false,false)~=nil
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.acfilter,tp,0,LOCATION_GRAVE,1,nil)  end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.acfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
			while tc do
			local tpe = tc:GetType()
			local te = tc:GetActivateEffect()
			local tg = te:GetTarget()
			local co = te:GetCost()
			local op = te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
			Duel.Hint(HINT_CARD, 0, tc:GetOriginalCode())
			tc:CreateEffectRelation(te)
			if (tpe & TYPE_EQUIP + TYPE_CONTINUOUS + TYPE_FIELD) == 0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:CancelToGrave(false)
			end
			if te:GetCode() == EVENT_CHAINING then
				local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
				local tc = te2:GetHandler()
				local g = Group.FromCards(tc)
				local p = tc:GetControler()
				if co then co(te, tp, g, p, chain, te2, REASON_EFFECT, p, 1) end
				if tg then tg(te, tp, g, p, chain, te2, REASON_EFFECT, p, 1) end
			elseif te:GetCode() == EVENT_FREE_CHAIN then
				if co then co(te, tp, eg, ep, ev, re, r, rp, 1) end
				if tg then tg(te, tp, eg, ep, ev, re, r, rp, 1) end
			else
				local res, teg, tep, tev, tre, tr, trp = Duel.CheckEvent(te:GetCode(), true)
				if co then co(te, tp, teg, tep, tev, tre, tr, trp, 1) end
				if tg then tg(te, tp, teg, tep, tev, tre, tr, trp, 1) end
			end
			Duel.BreakEffect()
			local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
			if g then
				local etc = g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc = g:GetNext()
				end
			end
			tc:SetStatus(STATUS_ACTIVATED, true)
			if not tc:IsDisabled() then
				if te:GetCode() == EVENT_CHAINING then
					local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
					local tc = te2:GetHandler()
					local g = Group.FromCards(tc)
					local p = tc:GetControler()
					if op then op(te, tp, g, p, chain, te2, REASON_EFFECT, p) end
				elseif te:GetCode() == EVENT_FREE_CHAIN then
					if op then op(te, tp, eg, ep, ev, re, r, rp) end
				else
					local res, teg, tep, tev, tre, tr, trp = Duel.CheckEvent(te:GetCode(), true)
					if op then op(te, tp, teg, tep, tev, tre, tr, trp) end
				end
			else
			end
			Duel.RaiseEvent(Group.CreateGroup(tc), EVENT_CHAIN_SOLVED, te, 0, tp, tp, Duel.GetCurrentChain())
			if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
				Duel.Equip(tp, tc, g:GetFirst())
			end
			tc:ReleaseEffectRelation(te)
			if etc then
				etc = g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc = g:GetNext()
				end
			end
			tc = ag:GetNext()
		end
	end
end